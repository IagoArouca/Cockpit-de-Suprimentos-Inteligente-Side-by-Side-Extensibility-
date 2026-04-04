const cds = require('@sap/cds');

module.exports = class SuprimentosService extends cds.ApplicationService {

    async init() {

        const LOG = cds.log('suprimentos')
        LOG.info('Iniciando o serviço de suprimentos...')

        const { AvaliacoesFornecedor, FornecedoresS4 } = this.entities;

        this.on('READ', FornecedoresS4, (req, next) => this.handleS4Integration(req, next))

        this.before(['NEW', 'CREATE', 'UPDATE'], AvaliacoesFornecedor, req => {
            this.setInitialStatus(req)
        })

        this.before(['CREATE', 'UPDATE'], AvaliacoesFornecedor, req => {
            this.validateEvaluation(req)
        })
        this.after('CREATE', AvaliacoesFornecedor, (data, req) => this.sendCriticalAlertEmail(data, req))

        this.after('READ', AvaliacoesFornecedor, each => this.calculateCriticality(each))

        this.before('DELETE', AvaliacoesFornecedor, req => this.validateDelete(req))

        await super.init()
    }

    setInitialStatus(req) {
        console.log("✨ Evento disparado:", req.event)
        const LOG = cds.log('suprimentos')

        if (req.data.statusAnalise_status === undefined || req.data.statusAnalise_status === null) {
            req.data.statusAnalise_status = 'NOVO'
            LOG.info('Status de análise definido como NOVO para a avaliação do fornecedor.')
        }
    }

    validateEvaluation(req) {
        const { notaDesempenho, comentarios, businessPartner_BusinessPartner} = req.data

        if(!businessPartner_BusinessPartner) {
            return req.reject(400, 'Você deve selecionar um fornecedor do S/4Hana.')
        }

        if(notaDesempenho !== undefined) {
            if (notaDesempenho < 1 || notaDesempenho > 5) {
                return req.reject(400, 'A nota de desempenho deve estar entre 1 e 5.', 'notaDesempenho')
            }
        }

        if (notaDesempenho <=2 && (!comentarios || comentarios.length < 10)) {
            return req.reject(400, 'Para notas iguais ou inferiores a 2, é obrigatório um parecer detalhado do comprador.', 'comentarios')
        }
    }

    async validateDelete(req) {
        const { AvaliacoesFornecedor } = this.entities
        const evaluation = await SELECT.one.from(AvaliacoesFornecedor).where({ ID: req.params[0].ID })
        const statusBloqueados = ['APROVADO', 'REPROVADO']
        if ( evaluation && statusBloqueados.includes(evaluation.statusAnalise_status) ) {
            return req.reject(403, `❌ Auditoria: Não é permitido excluir avaliações com status ${evaluation.statusAnalise_status}.`)
        }
    }

    async sendCriticalAlertEmail(data, req) {
        const LOG = cds.log('suprimentos')
        console.log("✨ Evento disparado:", req.event)
        const { notaDesempenho, businessPartner_BusinessPartner } = data

        if (notaDesempenho <= 2) {
            const fornecedor = data.businessPartner?.BusinessPartnerFullName || businessPartner_BusinessPartner
            
            LOG.warn(`⚠️  ALERTA DE QUALIDADE: Fornecedor ${fornecedor} recebeu nota ${notaDesempenho}`)
            LOG.info(`📧 [Simulação Email] Destinatário: gerente.compras@empresa.com`)
            LOG.info(`   Assunto: NOTIFICAÇÃO DE BAIXA PERFORMANCE - Fornecedor ${businessPartner_BusinessPartner}`)
            LOG.info(`   Corpo: Prezado Gerente, uma nova avaliação com nota ${notaDesempenho} foi registrada.`)
            LOG.info(`✅ Log de envio gerado com sucesso.`)
        }
    }

    async handleS4Integration(req, next) {
        try {
            return await next()
        } catch (error) {
            const LOG = cds.log('suprimentos')
            LOG.error('❌ Falha Crítica na API S/4HANA:', error.message)
            return req.error(503, 'Serviço de Fornecedores S/4HANA indisponível. Tente novamente mais tarde.')
        }
    }

    calculateCriticality(data) {
        const assessments = Array.isArray(data) ? data : [data]
        assessments.forEach(item => {
            if (item.notaDesempenho >=4 ) item.criticality = 3
            else if (item.notaDesempenho === 3) item.criticality = 2
            else if (item.notaDesempenho <=2 ) item.criticality = 1
            else item.criticality = 0

            if(item.createdAt) {
                let dataCriacao = new Date(item.createdAt)
                let diasParaAdicionar = item.notaDesempenho <= 2 ? 30 : 180

                dataCriacao.setDate(dataCriacao.getDate() + diasParaAdicionar)
                item.proximaRevisao = dataCriacao.toISOString().split('T')[0]
            }
        })
    }
}
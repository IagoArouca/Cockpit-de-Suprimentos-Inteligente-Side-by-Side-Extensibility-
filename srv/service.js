const cds = require('@sap/cds');

module.exports = class SuprimentosService extends cds.ApplicationService {

    async init() {

        const LOG = cds.log('suprimentos')
        LOG.info('Iniciando o serviço de suprimentos...')

        const { AvaliacoesFornecedor } = this.entities;

        this.before(['NEW', 'CREATE', 'UPDATE'], AvaliacoesFornecedor, req => {
            this.setInitialStatus(req)
        })

        this.before(['CREATE', 'UPDATE'], AvaliacoesFornecedor, req => {
            this.validateEvaluation(req)
        })
        this.after('CREATE', AvaliacoesFornecedor, (data, req) => this.sendCriticalAlertEmail(data, req))

        this.after('READ', AvaliacoesFornecedor, each => {
            if (each.notaDesempenho >= 4) {
                each.criticality = 3
            } else if (each.notaDesempenho === 3) {
                each.criticality = 2
            } else if (each.notaDesempenho <=2 ) {
                each.criticality = 1
            } else { 
                each.criticality = 0
            }
        })

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
}
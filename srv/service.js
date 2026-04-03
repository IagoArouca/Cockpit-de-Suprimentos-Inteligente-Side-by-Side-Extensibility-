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
}
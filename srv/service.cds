using { com.senior.suprimentos as my } from '../db/schema';
using { API_BUSINESS_PARTNER as external } from '../srv/external/API_BUSINESS_PARTNER';


service SuprimentosService {

    @odata.draft.enabled : true
    entity AvaliacoesFornecedor as projection on my.AvaliacoesFornecedor{
        *,
        virtual null as criticality : Integer,
        virtual null as proximaRevisao : Date,
        virtual null as statusCriticality : Integer
    } actions {

        @cds.odata.bindingparameter.name : '_it'
        @Common.SideEffects : { TargetProperties : ['_it/statusAnalise_status', '_it/statusCriticality'] }
        action aprovar();

        @cds.odata.bindingparameter.name : '_it'
        @Common.SideEffects : { TargetProperties : ['_it/statusAnalise_status', '_it/statusCriticality'] }
        action reprovar();
    }

    @reandonly
    entity FornecedoresS4 as projection on external.A_BusinessPartner {
        key BusinessPartner,
        BusinessPartnerFullName,
        BusinessPartnerGrouping,
        BusinessPartnerCategory
    };
}
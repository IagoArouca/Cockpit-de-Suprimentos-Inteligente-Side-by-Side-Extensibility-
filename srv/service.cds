using { com.senior.suprimentos as my } from '../db/schema';
using { API_BUSINESS_PARTNER as external } from '../srv/external/API_BUSINESS_PARTNER';


service SuprimentosService {

    @odata.draft.enabled : true
    entity AvaliacoesFornecedor as projection on my.AvaliacoesFornecedor;

    @reandonly
    entity FornecedoresS4 as projection on external.A_BusinessPartner {
        key BusinessPartner,
        BusinessPartnerFullName,
        BusinessPartnerGrouping,
        BusinessPartnerCategory
    };
}
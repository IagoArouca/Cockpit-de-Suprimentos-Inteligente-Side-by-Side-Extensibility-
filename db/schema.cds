namespace com.senior.suprimentos;

using { managed, cuid, sap.common.CodeList} from '@sap/cds/common';

using { API_BUSINESS_PARTNER as external } from '../srv/external/API_BUSINESS_PARTNER';

entity AvaliacoesFornecedor : managed, cuid {
    businessPartner  : Association to external.A_BusinessPartner;
    notaDesempenho   : Integer @assert.range: [1, 5];
    comentarios      : String(1000);
    statusAnalise    : Association to StatusAnalise

}

entity StatusAnalise  : CodeList {
    key status : String(20);
}


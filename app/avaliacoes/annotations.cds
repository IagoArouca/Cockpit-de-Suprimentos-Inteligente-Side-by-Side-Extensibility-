using SuprimentosService as service from '../../srv/service';
annotate service.AvaliacoesFornecedor with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'businessPartner_BusinessPartner',
                Value : businessPartner_BusinessPartner,
            },
            {
                $Type : 'UI.DataField',
                Label : 'notaDesempenho',
                Value : notaDesempenho,
            },
            {
                $Type : 'UI.DataField',
                Label : 'comentarios',
                Value : comentarios,
            },
            {
                $Type : 'UI.DataField',
                Label : 'statusAnalise_status',
                Value : statusAnalise_status,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'businessPartner_BusinessPartner',
            Value : businessPartner_BusinessPartner,
        },
        {
            $Type : 'UI.DataField',
            Label : 'notaDesempenho',
            Value : notaDesempenho,
        },
        {
            $Type : 'UI.DataField',
            Label : 'comentarios',
            Value : comentarios,
        },
        {
            $Type : 'UI.DataField',
            Label : 'statusAnalise_status',
            Value : statusAnalise_status,
        },
    ],
);

annotate service.AvaliacoesFornecedor with {
    businessPartner @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'FornecedoresS4',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : businessPartner_BusinessPartner,
                ValueListProperty : 'BusinessPartner',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'BusinessPartnerFullName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'BusinessPartnerGrouping',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'BusinessPartnerCategory',
            },
        ],
    }
};


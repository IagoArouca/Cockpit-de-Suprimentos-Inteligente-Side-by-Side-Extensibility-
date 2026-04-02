using SuprimentosService as service from './service';

annotate service.AvaliacoesFornecedor with @(
    UI.SelectionFields : [ businessPartner_BusinessPartner, statusAnalise_status ], 
    UI.LineItem : [
        { $Type : 'UI.DataField', Label : 'ID Fornecedor', Value : businessPartner_BusinessPartner },
        { $Type : 'UI.DataField', Label : 'Nota (1-5)', Value : notaDesempenho },
        { $Type : 'UI.DataField', Label : 'Status', Value : statusAnalise_status },
        { $Type : 'UI.DataField', Label : 'Data de Avaliação', Value : createdAt },
        { $Type : 'UI.DataField', Label : 'Comentários', Value : comentarios }
    ],
    UI.HeaderInfo : {
        TypeName : 'Avaliação',
        TypeNamePlural : 'Avaliações de Fornecedores',
        Title : { Value : businessPartner_BusinessPartner },
        Description : { Value : 'Análise detalhada de performance' }
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'InfoGeral',
            Label : 'Informações da Avaliação',
            Target : '@UI.FieldGroup#Detalhes'
        }
    ],
    UI.FieldGroup #Detalhes : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { Value : businessPartner_BusinessPartner, Label : 'Fornecedor' },
            { Value : notaDesempenho, Label : 'Nota de Desempenho' },
            { Value : statusAnalise_status, Label : 'Status da Análise' },
            { Value : comentarios, Label : 'Parecer do Comprador' }
        ]
    }
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
            }
        ],
    }
};
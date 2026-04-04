using SuprimentosService as service from './service';

annotate service.AvaliacoesFornecedor with @(
    UI.SelectionFields : [ businessPartner_BusinessPartner, statusAnalise_status ], 
    UI.LineItem : [
        { $Type : 'UI.DataField', Label : 'Fornecedor', Value : businessPartner_BusinessPartner },
        { $Type : 'UI.DataField', Label : 'Nota (1-5)', Value : notaDesempenho, Criticality : criticality },
        { $Type : 'UI.DataField', Label : 'Status', Value : statusAnalise_status, Criticality : statusCriticality  },
        { $Type : 'UI.DataField', Label : 'Data de Avaliação', Value : createdAt },
        { $Type : 'UI.DataField', Value : proximaRevisao, Label : 'Próxima Revisão' }
    ],
    UI.HeaderInfo : {
        TypeName : 'Avaliação',
        TypeNamePlural : 'Avaliações de Fornecedores',
        Title : { Value : businessPartner.BusinessPartnerFullName }, 
        Description : { Value : businessPartner_BusinessPartner }  
    },

    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.DataPoint#NotaHeader',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.DataPoint#StatusHeader',
        }
    ],

    UI.DataPoint #NotaHeader : {
        Value : notaDesempenho,
        Title : 'Nota de Desempenho',
        Criticality : criticality
    },
    UI.DataPoint #StatusHeader : {
        Value : statusAnalise_status,
        Title : 'Status Atual',
        Criticality : statusCriticality 
    },

    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'service.aprovar',
            Label : 'Aprovar',
            Criticality : #Positive,

            @UI.Hidden : { $edmJson: { $Or: [
                { $Eq: [ { $Path: 'statusAnalise_status' }, 'APROVADO' ] },
                { $Eq: [ { $Path: 'statusAnalise_status' }, 'REPROVADO' ] }
            ]}}
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'service.reprovar',
            Label : 'Reprovar',
            Criticality : #Negative,

            @UI.Hidden : { $edmJson: { $Or: [
                { $Eq: [ { $Path: 'statusAnalise_status' }, 'APROVADO' ] },
                { $Eq: [ { $Path: 'statusAnalise_status' }, 'REPROVADO' ] }
            ]}}
        }
    ],

    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'SessaoDadosFornecedor',
            Label : 'Dados do Fornecedor',
            Target : '@UI.FieldGroup#DadosBP'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'SessaoAvaliacao',
            Label : 'Detalhes da Avaliação',
            Target : '@UI.FieldGroup#DetalhesAvaliacao'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'SessaoPlanejamento',
            Label : 'Planejamento e Auditoria',
            Target : '@UI.FieldGroup#Admin'
        }
    ],

    UI.FieldGroup #DadosBP : {
        Data : [
            { Value : businessPartner_BusinessPartner, Label : 'Código BP' },
            { Value : businessPartner.BusinessPartnerFullName, Label : 'Nome Completo' },
            { Value : businessPartner.BusinessPartnerGrouping, Label : 'Grupo de Conta' }
        ]
    },

    UI.FieldGroup #DetalhesAvaliacao : {
        Data : [
            { Value : notaDesempenho, Label : 'Nota (1-5)', Criticality : criticality },
            { Value : statusAnalise_status, Label : 'Status da Análise' },
            { 
                $Type : 'UI.DataField', 
                Value : comentarios, 
                Label : 'Parecer Técnico',
                @UI.MultiLineText : true 
            }
        ]
    },

    UI.FieldGroup #Admin : {
        Data : [
            { Value : createdAt, Label : 'Data de Criação' },
            { Value : proximaRevisao, Label : 'Data da Próxima Revisão' },
            { Value : createdBy, Label : 'Comprador Responsável' }
        ]
    }
);

annotate service.AvaliacoesFornecedor with @(
    UI.UpdateHidden : { $edmJson: { $Or: [
        { $Eq: [ { $Path: 'statusAnalise_status' }, 'APROVADO' ] },
        { $Eq: [ { $Path: 'statusAnalise_status' }, 'REPROVADO' ] }
    ]}}
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

annotate service.AvaliacoesFornecedor with {
    statusAnalise @Common.ValueListWithFixedValues : true;
};

annotate service.AvaliacoesFornecedor with {
    businessPartner @Common.Text : businessPartner.BusinessPartnerFullName
                    @Common.TextArrangement : #TextFirst;
};

annotate service.AvaliacoesFornecedor @Common.SideEffects : {
    $Type : 'Common.SideEffectsType',
    SourceProperties : [ notaDesempenho ],
    TargetProperties : [ criticality, proximaRevisao, statusCriticality ]
};

annotate service.AvaliacoesFornecedor @Common.SideEffects #ActionRefreshes : {
    SourceEntities : [ ],
    TargetProperties : [ statusAnalise_status, statusCriticality, criticality ]
};


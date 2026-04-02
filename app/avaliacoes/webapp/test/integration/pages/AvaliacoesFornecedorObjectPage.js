sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'com.senior.suprimentos.avaliacoes',
            componentId: 'AvaliacoesFornecedorObjectPage',
            contextPath: '/AvaliacoesFornecedor'
        },
        CustomPageDefinitions
    );
});
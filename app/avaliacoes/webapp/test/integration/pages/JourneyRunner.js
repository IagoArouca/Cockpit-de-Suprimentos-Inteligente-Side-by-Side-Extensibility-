sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/senior/suprimentos/avaliacoes/test/integration/pages/AvaliacoesFornecedorList",
	"com/senior/suprimentos/avaliacoes/test/integration/pages/AvaliacoesFornecedorObjectPage"
], function (JourneyRunner, AvaliacoesFornecedorList, AvaliacoesFornecedorObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/senior/suprimentos/avaliacoes') + '/test/flp.html#app-preview',
        pages: {
			onTheAvaliacoesFornecedorList: AvaliacoesFornecedorList,
			onTheAvaliacoesFornecedorObjectPage: AvaliacoesFornecedorObjectPage
        },
        async: true
    });

    return runner;
});


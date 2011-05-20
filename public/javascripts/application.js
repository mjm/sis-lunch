// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

(function() {
	new Ajax.PeriodicalUpdater('places', '/periodic', {
		method: 'get',
		onComplete: function() {
			new Effect.Highlight('places');
		}
	});
})();
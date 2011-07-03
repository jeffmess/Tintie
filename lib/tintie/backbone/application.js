var App = {
    Views: {},
    Controllers: {},
    init: function() {
        new App.Controllers.Tasks();
        Backbone.history.start();
    }
};
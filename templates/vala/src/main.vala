
int main (string[] argv) {
    // Create a new application
    var app = new Gtk.Application ("com.example.GtkApplication",
                                   GLib.ApplicationFlags.DEFAULT_FLAGS);

    app.activate.connect (() => {
        // Create a new window
        var window = new Gtk.ApplicationWindow (app);

        // Create a new button
        var button = new Gtk.Button.with_label ("Hello, World!");

        // When the button is clicked, close the window
        button.clicked.connect (() => {
            window.close ();
        });

        window.set_child (button);
        window.present ();
    });

    return app.run (argv);
}

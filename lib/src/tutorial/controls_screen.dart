part of tutorial;

class ControlsScreen extends TutorialDialog {

	ControlsScreen(UIInterface ui, Tutorial tutorial) :
		super(ui, tutorial, "", null);

	void _init(UIInterface ui) {
		View info = new View(ui);

		View movementView = new View(ui);
		TextView movementTextView = new TextView(ui, "Movement");
		movementTextView.evaluateVars();
		ImageView klView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_Arrow_Left.png", 24, 24);
		ImageView krView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_Arrow_Right.png", 24, 24);
		ImageView kuView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_Arrow_Up.png", 24, 24);
		ImageView kdView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_Arrow_Down.png", 24, 24);
		ClearView kcView = new ClearView(ui);
		TextView movementOrView = new TextView(ui, " OR ");
		movementOrView.evaluateVars();
		ImageView aView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_A.png", 24, 24);
        ImageView sView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_S.png", 24, 24);
        ImageView wView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_W.png", 24, 24);
        ImageView dView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_D.png", 24, 24);
        ClearView cView = new ClearView(ui);

        movementTextView.style.fontWeight = "bold";
		klView.style.float = "left";
		krView.style.float = "left";
		kuView.style.float = "left";
		kdView.style.float = "left";
        aView.style.float = "left";
        sView.style.float = "left";
        dView.style.float = "left";
        wView.style.float = "left";

        View pauseView = new View(ui);
        TextView pauseTextView = new TextView(ui, "Pause/options");
        pauseTextView.evaluateVars();
        ImageView pView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_P.png", 24, 24);
        pauseTextView.style.fontWeight = "bold";
        pView.style.float = "left";



		movementView
			..addView(movementTextView)
			..addView(klView)
			..addView(kdView)
			..addView(kuView)
			..addView(krView)
			..addView(kcView)
			..addView(movementOrView)
			..addView(aView)
			..addView(sView)
			..addView(dView)
			..addView(wView)
			..addView(cView);

        pauseView
            ..addView(pauseTextView)
            ..addView(pView)
            ..addView(new ClearView(ui));


        TextView controlsTextView = new TextView(ui, "Controls");
        controlsTextView.evaluateVars();

		info
			..addView(controlsTextView)
			..addView(movementView)
			..addView(pauseView);

		this.addView(info);

        super._init(ui);
	}
}

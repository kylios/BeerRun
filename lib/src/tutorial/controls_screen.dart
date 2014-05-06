part of tutorial;

class ControlsScreen extends TutorialDialog {

	ControlsScreen(UIInterface ui, Tutorial tutorial) :
		super(ui, tutorial, "");

	void _init(UIInterface ui) {
		View info = new View(ui);

		View movementView = new View(ui);
		TextView movementTextView = new TextView(ui, "Movement: ");
		ImageView klView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_Arrow_Left.png", 24, 24);
		ImageView krView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_Arrow_Right.png", 24, 24);
		ImageView kuView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_Arrow_Up.png", 24, 24);
		ImageView kdView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_Arrow_Down.png", 24, 24);
		TextView movementOrView = new TextView(ui, " OR ");
		ImageView aView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_A.png", 24, 24);
        ImageView sView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_S.png", 24, 24);
        ImageView dView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_D.png", 24, 24);
        ImageView wView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_W.png", 24, 24);

		movementTextView.style.float = "left";
		klView.style.float = "left";
		krView.style.float = "left";
		kuView.style.float = "left";
		kdView.style.float = "left";
		movementOrView.style.float = "left";
        aView.style.float = "left";
        sView.style.float = "left";
        dView.style.float = "left";
        wView.style.float = "left";

        View pauseView = new View(ui);
        TextView pauseTextView = new TextView(ui, "Pause/options: ");
        ImageView pView = new ImageView.fromSrc(ui, "assets/ui/keyboard/Keyboard_White_P.png", 24, 24);
        pauseTextView.style.float = "left";
        pView.style.float = "left";



		movementView
			..addView(movementTextView)
			..addView(klView)
			..addView(kdView)
			..addView(kuView)
			..addView(krView)
			..addView(movementOrView)
			..addView(aView)
			..addView(sView)
			..addView(dView)
			..addView(wView)
			..addView(new ClearView(ui));

        pauseView
            ..addView(pauseTextView)
            ..addView(pView)
            ..addView(new ClearView(ui));



		info
			..addView(new TextView(ui, "Controls"))
			..addView(movementView)
			..addView(pauseView);

		this.addView(info);

        super._init(ui);
	}
}
package ca.gbc.mobile.moshapp;

import org.apache.cordova.*;
import android.os.Bundle;

public class MoshLoad extends DroidGap {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	    super.setIntegerProperty("splashscreen", R.drawable.splash);
		// Set by <content src="index.html" /> in config.xml
        super.loadUrl(Config.getStartUrl(),5000);
		//super.loadUrl("file:///android_asset/www/index.html",5000);
	}

}

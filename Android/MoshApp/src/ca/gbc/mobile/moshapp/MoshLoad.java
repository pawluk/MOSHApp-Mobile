package ca.gbc.mobile.moshapp;

import org.apache.cordova.DroidGap;

import android.os.Bundle;

public class MoshLoad extends DroidGap {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	    super.setIntegerProperty("splashscreen", R.drawable.splash);
		super.loadUrl("file:///android_asset/www/index.html",5000);
	}

}

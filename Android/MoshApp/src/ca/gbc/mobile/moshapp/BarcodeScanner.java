/**
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) Matt Kane 2010
 * Copyright (c) 2011, IBM Corporation
 */

package ca.gbc.mobile.moshapp;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.sax.StartElementListener;
import android.util.Log;

import org.apache.cordova.api.CallbackContext;
import org.apache.cordova.api.CordovaPlugin;
import org.apache.cordova.api.PluginResult;

/**
 * This calls out to the ZXing barcode reader and returns the result.
 */
public class BarcodeScanner extends CordovaPlugin {
    private static final String SCAN = "scan";
    private static final String CANCELLED = "cancelled";
    private static final String FORMAT = "format";
    private static final String TEXT = "text";
    private static final String SCAN_INTENT = "jim.h.common.android.lib.zxing.SCAN";

    public static final int REQUEST_CODE = 0x0ba7c0de;

    public CallbackContext callbackContext;

    /**
     * Constructor.
     */
    public BarcodeScanner() {
    }

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action        The action to execute.
     * @param args          JSONArray of arguments for the plugin.
     * @param callbackId    The callback id used when calling back into JavaScript.
     * @return              A PluginResult object with a status and message.
     */
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        this.callbackContext = callbackContext;
       if (action.equals(SCAN)) {
            scan();
            return true;
        }
       return false;

    }


    /**
     * Starts an intent to scan and decode a barcode.
     */
    public void scan() {
    	
    	
        Intent intentScan = new Intent(SCAN_INTENT);
        intentScan.putExtra("SCAN_MODE", "QR_CODE_MODE");
       // intentScan.addCategory(Intent.CATEGORY_DEFAULT);   
        this.cordova.startActivityForResult((CordovaPlugin) this, intentScan, REQUEST_CODE);
    }

    /**
     * Called when the barcode scanner intent completes
     *
     * @param requestCode       The request code originally supplied to startActivityForResult(),
     *                          allowing you to identify who this result came from.
     * @param resultCode        The integer result code returned by the child activity through its setResult().
     * @param intent            An Intent, which can return result data to the caller (various data can be attached to Intent "extras").
     */
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                JSONObject obj = new JSONObject();
                try {
                    obj.put(TEXT, intent.getStringExtra("SCAN_RESULT"));
                    obj.put(FORMAT, intent.getStringExtra("SCAN_RESULT_FORMAT"));
                    obj.put(CANCELLED, false);
                } catch(JSONException e) {
                    //Log.d(LOG_TAG, "This should never happen");
                }
                this.
                callbackContext.success(obj);
            } if (resultCode == Activity.RESULT_CANCELED) {
                JSONObject obj = new JSONObject();
                try {
                    obj.put(TEXT, "");
                    obj.put(FORMAT, "");
                    obj.put(CANCELLED, true);
                } catch(JSONException e) {
                    //Log.d(LOG_TAG, "This should never happen");
                }
                callbackContext.success(obj);
            } else {
            	callbackContext.error(1000);
            }
        }
    }
}
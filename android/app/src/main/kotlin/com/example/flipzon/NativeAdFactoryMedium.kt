package com.example.flipzon

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class NativeAdFactoryMedium(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = LayoutInflater.from(context)
            .inflate(R.layout.native_ads_medium, null) as NativeAdView

        // Headline
        val headlineView = adView.findViewById<TextView>(R.id.native_ad_headline)
        headlineView.text = nativeAd.headline
        adView.headlineView = headlineView

        // Body
        val bodyView = adView.findViewById<TextView>(R.id.native_ad_body)
        bodyView.text = nativeAd.body
        adView.bodyView = bodyView

        // Call to action
        val callToActionView = adView.findViewById<Button>(R.id.native_ad_button)
        callToActionView.text = nativeAd.callToAction
        adView.callToActionView = callToActionView

        // Media view
        val mediaView = adView.findViewById<com.google.android.gms.ads.nativead.MediaView>(R.id.native_ad_media)
        adView.mediaView = mediaView

        // Icon
        val iconView = adView.findViewById<ImageView>(R.id.native_ad_icon) // Changed from ad_icon to native_ad_icon
        if (nativeAd.icon != null) {
            iconView.setImageDrawable(nativeAd.icon?.drawable)
            iconView.visibility = View.VISIBLE
        } else {
            iconView.visibility = View.GONE
        }
        adView.iconView = iconView

        // Associate the NativeAd object with the view
        adView.setNativeAd(nativeAd)

        return adView
    }
}
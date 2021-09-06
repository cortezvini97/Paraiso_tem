package com.vcinsidedigital.vcid;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.speech.RecognizerIntent;
import android.widget.Toast;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.Locale;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity
{
    private static final String CHANNEL = "com.vcinsidedigital.mic/microfone";
    private static final int REQUEST_CODE_SPEECH_INPUT = 1000;
    private String textoBusca = "";
    private String textoBuscaModif = "";
    private MethodChannel.Result resultado;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine)
    {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler()
        {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result)
            {
                if (call.method.equals("iniciar"))
                {
                    capturarVoz();
                    resultado = result;
                }
            }
        });
    }
    public void capturarVoz()
    {
        Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault());
        intent.putExtra(RecognizerIntent.EXTRA_PROMPT, "Busca por voz");

        try
        {
            startActivityForResult(intent, REQUEST_CODE_SPEECH_INPUT);
        }catch (Exception e)
        {
            e.getMessage();
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode)
        {
            case REQUEST_CODE_SPEECH_INPUT:
            {
                if (resultCode == RESULT_OK && null != data)
                {
                    ArrayList<String> result = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
                    textoBusca = result.get(0);

                    textoBuscaModif = textoBusca.replace("-", "");
                    resultado.success(textoBuscaModif);
                }
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults)
    {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        for (int permisaoResultado : grantResults)
        {
            if (permisaoResultado == PackageManager.PERMISSION_DENIED)
            {

            }else
            {

            }
        }
    }
}

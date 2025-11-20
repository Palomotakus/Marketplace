/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.frontend.servicio;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;

/**
 *
 * @author luisc
 */
public class ReniecServicio {
    
    private static final String API_URL = "https://api.decolecta.com/v1/reniec/dni?numero=";
    private static final String TOKEN = "Bearer sk_10260.UIqolIlkRhLbXZFatKW6HnnluyyZtj32";

    public JSONObject buscarPorDni(String dni) throws Exception {
        if (dni == null || dni.length() != 8 || !dni.matches("\\d+")) {
            throw new IllegalArgumentException("DNI inválido. Debe tener 8 dígitos numéricos.");
        }

        URL url = new URL(API_URL + dni);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");
        conn.setRequestProperty("Authorization", TOKEN);

        int status = conn.getResponseCode();
        if (status != 200) {
            throw new Exception("No se pudo obtener datos del servicio. Código: " + status);
        }

        // Leer respuesta
        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        br.close();
        conn.disconnect();

        return new JSONObject(sb.toString());
    }
    
}

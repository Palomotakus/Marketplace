package com.mycompany.frontend.servicio;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;


public class CurrencyServicio {

    private static final String TOKEN = "sk_10868.OKJwQ0OYCiBQdZlHI1sQS0X25Vy8jbs2";
    private static final String API_URL = "https://api.decolecta.com/v1/tipo-cambio/sunat";

    public static double obtenerTipoCambioVenta() {
        double tipoCambio = 3.50; // Valor por defecto (por si la API falla)
        try {
            String fecha = java.time.LocalDate.now().toString();
            URL url = new URL(API_URL + "?date=" + fecha);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + TOKEN);

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) {
                response.append(line);
            }
            in.close();

            JSONObject json = new JSONObject(response.toString());
            tipoCambio = json.getDouble("sell_price");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return tipoCambio;
    }
}

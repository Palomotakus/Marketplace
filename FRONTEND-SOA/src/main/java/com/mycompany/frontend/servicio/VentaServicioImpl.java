package com.mycompany.frontend.servicio;

import com.mycompany.frontend.entidades.DetalleVenta;
import com.mycompany.frontend.entidades.Venta;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

public class VentaServicioImpl implements VentaServicio {

    private static final String BASE_URL = "http://localhost:8003/api/ventas";

    // ======================================================
    // 1. REGISTRAR VENTA (POST)
    // ======================================================
    @Override
    public Venta registrarVenta(Venta venta, List<DetalleVenta> detalles) {
        try {
            URL url = new URL(BASE_URL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);

            JSONObject json = new JSONObject();
            json.put("dni", venta.getDni());
            json.put("nombre", venta.getNombre());
            json.put("apellidoPaterno", venta.getApellidoPaterno());
            json.put("apellidoMaterno", venta.getApellidoMaterno());
            json.put("fecha", venta.getFecha().toString());
            json.put("total", venta.getTotal());
            json.put("estado", venta.getEstado());

            JSONArray arrDetalles = new JSONArray();
            for (DetalleVenta d : detalles) {
                JSONObject obj = new JSONObject();

                JSONObject libroObj = new JSONObject();
                libroObj.put("id", d.getIdLibro());

                obj.put("libro", libroObj);
                obj.put("cantidad", d.getCantidad());
                obj.put("precioUnitario", d.getPrecioUnitario());
                obj.put("subtotal", d.getSubtotal());

                arrDetalles.put(obj);
            }

            json.put("detalles", arrDetalles);

            try (OutputStream os = con.getOutputStream()) {
                os.write(json.toString().getBytes("UTF-8"));
            }

            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            JSONObject response = new JSONObject(in.readLine());
            in.close();

            return convertir(response);

        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

    // ======================================================
    // 2. LISTAR TODAS LAS VENTAS (GET /api/ventas)
    // ======================================================
    @Override
    public List<Venta> findAll() {
        List<Venta> lista = new ArrayList<>();

        try {
            URL url = new URL(BASE_URL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("Accept", "application/json");

            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            String line = in.readLine();
            in.close();

            JSONArray array = new JSONArray(line);

            for (int i = 0; i < array.length(); i++) {
                lista.add(convertir(array.getJSONObject(i)));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    // ======================================================
    // 3. BUSCAR VENTAS (GET /api/ventas/buscar)
    // ======================================================
    @Override
    public List<Venta> buscarVentas(String idVenta, String dni, String fecha) {
        List<Venta> lista = new ArrayList<>();

        try {
            StringBuilder urlStr = new StringBuilder(BASE_URL + "/buscar?");

            if (idVenta != null && !idVenta.isBlank()) {
                urlStr.append("idVenta=").append(idVenta).append("&");
            }
            if (dni != null && !dni.isBlank()) {
                urlStr.append("dni=").append(dni).append("&");
            }
            if (fecha != null && !fecha.isBlank()) {
                urlStr.append("fecha=").append(fecha).append("&");
            }

            String urlFinal = urlStr.toString();
            if (urlFinal.endsWith("&") || urlFinal.endsWith("?")) {
                urlFinal = urlFinal.substring(0, urlFinal.length() - 1);
            }

            URL url = new URL(urlFinal);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("Accept", "application/json");

            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            String line = in.readLine();
            in.close();

            JSONArray array = new JSONArray(line);

            for (int i = 0; i < array.length(); i++) {
                lista.add(convertir(array.getJSONObject(i)));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    // ======================================================
    // Convertir JSON → Venta (CON DETALLES)
    // ======================================================
    private Venta convertir(JSONObject obj) {
        Venta v = new Venta();

        if (obj.has("id")) v.setId(obj.getInt("id"));
        if (obj.has("dni")) v.setDni(obj.getString("dni"));
        if (obj.has("nombre")) v.setNombre(obj.getString("nombre"));
        if (obj.has("apellidoPaterno")) v.setApellidoPaterno(obj.getString("apellidoPaterno"));
        if (obj.has("apellidoMaterno")) v.setApellidoMaterno(obj.getString("apellidoMaterno"));
        if (obj.has("fecha")) v.setFecha(java.time.LocalDateTime.parse(obj.getString("fecha")));
        if (obj.has("total")) v.setTotal(obj.getDouble("total"));
        if (obj.has("estado")) v.setEstado(obj.getString("estado"));

        // ================================
        //   🚀 CONVERTIR DETALLES
        // ================================
        List<DetalleVenta> detalles = new ArrayList<>();

        if (obj.has("detalles")) {
            JSONArray arr = obj.getJSONArray("detalles");

            for (int i = 0; i < arr.length(); i++) {
                JSONObject d = arr.getJSONObject(i);

                DetalleVenta det = new DetalleVenta();

                if (d.has("id")) det.setId(d.getInt("id"));
                if (d.has("cantidad")) det.setCantidad(d.getInt("cantidad"));
                if (d.has("precioUnitario")) det.setPrecioUnitario(d.getDouble("precioUnitario"));
                if (d.has("subtotal")) det.setSubtotal(d.getDouble("subtotal"));

                // libro viene como objeto
                if (d.has("libro")) {
                    JSONObject libroObj = d.getJSONObject("libro");
                    if (libroObj.has("id")) {
                        det.setIdLibro(libroObj.getInt("id"));
                    }
                }

                detalles.add(det);
            }
        }

        v.setDetalles(detalles);

        return v;
    }
}

package com.mycompany.frontend.servicio;

import com.mycompany.frontend.entidades.Empleado;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;
import org.json.JSONArray;
import org.json.JSONObject;

public class EmpleadoServicioImpl implements EmpleadoServicio {

    private static final String BASE_URL = "http://localhost:8001/api/empleados";

    @Override
    public Empleado findById(int id) {
        try {
            URL url = new URL(BASE_URL + "/" + id);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("Accept", "application/json");

            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            JSONObject obj = new JSONObject(in.readLine());
            in.close();

            return convertir(obj);

        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Empleado> findAll() {
        List<Empleado> lista = new ArrayList<>();
        try {
            URL url = new URL(BASE_URL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("Accept", "application/json");

            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            JSONArray arr = new JSONArray(in.readLine());
            in.close();

            for (int i = 0; i < arr.length(); i++) {
                lista.add(convertir(arr.getJSONObject(i)));
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }

    @Override
    public void guardar(Empleado empleado) {
        try {
            URL url = new URL(BASE_URL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);

            JSONObject json = new JSONObject();
            if (empleado.getId() != null) {
                json.put("id", empleado.getId());
            }
            json.put("dni", empleado.getDni());
            json.put("nombre", empleado.getNombre());
            json.put("usuario", empleado.getUsuario());
            json.put("contrasena", empleado.getContrasena());
            json.put("rol", empleado.getRol());
            json.put("fechaRegistro", empleado.getFechaRegistro());
            json.put("estado", "Activo");

            try (OutputStream os = con.getOutputStream()) {
                os.write(json.toString().getBytes("UTF-8"));
            }

            con.getResponseCode();

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    @Override
    public void actualizar(Empleado empleado) {
        guardar(empleado); // Spring usa POST para crear/actualizar
    }

    @Override
    public void eliminar(int id) {
        try {
            URL url = new URL(BASE_URL + "/eliminar/" + id);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.getResponseCode();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    @Override
    public Map<String, Integer> obtenerEstadisticasEmpleados() {
        Map<String, Integer> mapa = new HashMap<>();
        try {
            URL url = new URL(BASE_URL + "/estadisticas");
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("Accept", "application/json");

            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            JSONObject obj = new JSONObject(in.readLine());
            in.close();

            for (String key : obj.keySet()) {
                mapa.put(key, obj.getInt(key));
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return mapa;
    }

    @Override
    public void actualizarEstado(String estado, int id) {
        try {
            URL url = new URL(BASE_URL + "/actualizar/estado/" + estado + "/" + id);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.getResponseCode();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    // ----------------------
    // MÉTODO PARA CREAR OBJETO
    // ----------------------
    private Empleado convertir(JSONObject obj) {
        Empleado e = new Empleado();
        e.setId(obj.getLong("id"));
        e.setDni(obj.getString("dni"));
        e.setNombre(obj.getString("nombre"));
        e.setUsuario(obj.getString("usuario"));
        e.setContrasena(obj.getString("contrasena"));
        e.setRol(obj.getString("rol"));
        e.setEstado(obj.getString("estado"));
        e.setFechaRegistro(obj.getString("fechaRegistro"));
        return e;
    }

    @Override
    public Empleado validarUsuario(String usuario, String contrasena) {
        try {
            URL url = new URL(BASE_URL + "/validar/" + usuario + "/" + contrasena);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("Accept", "application/json");

            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            JSONObject obj = new JSONObject(in.readLine());
            in.close();

            return convertir(obj);

        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

}

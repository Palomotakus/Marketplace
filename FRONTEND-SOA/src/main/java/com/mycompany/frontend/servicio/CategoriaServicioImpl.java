package com.mycompany.frontend.servicio;

import com.mycompany.frontend.entidades.Categoria;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

public class CategoriaServicioImpl implements CategoriaServicio {

    private static final String BASE_URL = "http://localhost:8002/api/inventario/categorias";

    @Override
    public Categoria findById(int id) {
        try {
            URL url = new URL(BASE_URL + "/id/" + id);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            JSONObject obj = new JSONObject(in.readLine());

            Categoria c = new Categoria();
            c.setId(obj.getLong("id"));
            c.setNombre(obj.getString("nombre"));

            return c;

        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Categoria> findAll() {
        List<Categoria> lista = new ArrayList<>();
        try {
            URL url = new URL(BASE_URL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            JSONArray arr = new JSONArray(in.readLine());

            for (int i = 0; i < arr.length(); i++) {
                JSONObject obj = arr.getJSONObject(i);
                Categoria c = new Categoria();
                c.setId(obj.getLong("id"));
                c.setNombre(obj.getString("nombre"));
                lista.add(c);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }

    @Override
    public void guardar(Categoria categoria) {
        try {
            URL url = new URL(BASE_URL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);

            JSONObject json = new JSONObject();
            if (categoria.getId() != null) json.put("id", categoria.getId());
            json.put("nombre", categoria.getNombre());

            try (OutputStream os = con.getOutputStream()) {
                os.write(json.toString().getBytes("UTF-8"));
            }

            con.getResponseCode(); // ejecuta la petición

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    @Override
    public void actualizar(Categoria categoria) {
        guardar(categoria);
    }

    @Override
    public void eliminar(int id) {
        try {
            URL url = new URL(BASE_URL + "/eliminar/" + id);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST"); // lo mantienes igual a tu controlador
            con.getResponseCode();

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    @Override
    public Map<Integer, Integer> obtenerCantidadLibrosPorCategoria() {
        Map<Integer, Integer> mapa = new HashMap<>();

        try {
            URL url = new URL(BASE_URL + "/librosxcategoria");
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            JSONObject obj = new JSONObject(br.readLine());

            for (String key : obj.keySet()) {
                mapa.put(Integer.parseInt(key), obj.getInt(key));
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return mapa;
    }

    @Override
    public Categoria validarCategoriaNombre(String nombre) {
        try {
            URL url = new URL(BASE_URL + "/nombre/" + nombre);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            JSONObject obj = new JSONObject(br.readLine());

            Categoria c = new Categoria();
            c.setId(obj.getLong("id"));
            c.setNombre(obj.getString("nombre"));
            return c;

        } catch (Exception ex) {
            return null; // si no existe devuelve null como tu implementación original
        }
    }
}

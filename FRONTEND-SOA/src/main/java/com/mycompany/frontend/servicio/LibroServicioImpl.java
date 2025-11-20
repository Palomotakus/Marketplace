package com.mycompany.frontend.servicio;

import com.mycompany.frontend.entidades.Categoria;
import com.mycompany.frontend.entidades.Libro;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

public class LibroServicioImpl implements LibroServicio {

    private static final String BASE_URL = "http://localhost:8002/api/inventario";

    // ============================================================
    //                  MÉTODO: findById
    // ============================================================
    @Override
    public Libro findById(int id) {
        try {
            URL url = new URL(BASE_URL + "/libros/id/" + id);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            if (con.getResponseCode() != 200) return null;

            BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            return convertir(new JSONObject(br.readLine()));

        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

    // ============================================================
    //                  MÉTODO: findAll
    // ============================================================
    @Override
    public List<Libro> findAll() {
        List<Libro> lista = new ArrayList<>();

        try {
            URL url = new URL(BASE_URL + "/libros");
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            JSONArray arr = new JSONArray(br.readLine());

            for (int i = 0; i < arr.length(); i++) {
                lista.add(convertir(arr.getJSONObject(i)));
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }

    // ============================================================
    //         CONVERTIR JSON A OBJETO LIBRO
    // ============================================================
    private Libro convertir(JSONObject obj) {
        Libro l = new Libro();
        l.setId(obj.getLong("id"));
        l.setCodigo(obj.getString("codigo"));
        l.setTitulo(obj.getString("titulo"));
        l.setAutor(obj.getString("autor"));
        l.setPrecio(obj.getDouble("precio"));
        l.setStock(obj.getInt("stock"));

        // --- Categoria anidada ---
        JSONObject catJson = obj.getJSONObject("categoria");

        Categoria c = new Categoria();
        c.setId(catJson.getLong("id"));
        c.setNombre(catJson.getString("nombre"));
        l.setCategoria(c);

        return l;
    }

    // ============================================================
    //                  MÉTODO: guardar
    // ============================================================
    @Override
    public void guardar(Libro libro) {
        try {
            URL url = new URL(BASE_URL + "/libros");
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);

            JSONObject categoriaJson = new JSONObject();
            categoriaJson.put("id", libro.getCategoria().getId());

            JSONObject json = new JSONObject();
            if (libro.getId() != null) json.put("id", libro.getId());
            json.put("codigo", libro.getCodigo());
            json.put("titulo", libro.getTitulo());
            json.put("autor", libro.getAutor());
            json.put("stock", libro.getStock());
            json.put("precio", libro.getPrecio());
            json.put("categoria", categoriaJson);

            OutputStream os = con.getOutputStream();
            os.write(json.toString().getBytes("UTF-8"));
            os.close();

            con.getResponseCode(); // para ejecutar el POST

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    // ============================================================
    //                  MÉTODO: actualizarStock
    // ============================================================
    @Override
    public void actualizarStock(int idLibro, int cantidadVendida) {
        try {
            URL url = new URL(BASE_URL + "/libros/actualizar-stock/" + idLibro + "/" + cantidadVendida);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.getResponseCode();

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    // ============================================================
    //                  MÉTODO: eliminar
    // ============================================================
    @Override
    public void eliminar(int id) {
        try {
            URL url = new URL(BASE_URL + "/libros/eliminar/" + id);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");

            con.getResponseCode();

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    // ============================================================
    //                  MÉTODO: obtenerResumen
    // ============================================================
    @Override
    public Map<String, Integer> obtenerResumen() {
        Map<String, Integer> mapa = new HashMap<>();

        try {
            URL url = new URL(BASE_URL + "/libros/obtener-resumen");
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            JSONObject obj = new JSONObject(br.readLine());

            for (String key : obj.keySet()) {
                mapa.put(key, obj.getInt(key));
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return mapa;
    }

    // ============================================================
    //                  MÉTODO: findByCodigo
    // ============================================================
    @Override
    public Libro findByCodigo(String codigo) {
        try {
            URL url = new URL(BASE_URL + "/libros/codigo/" + codigo);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));

            JSONArray arr = new JSONArray(br.readLine());
            if (arr.isEmpty()) return null;

            return convertir(arr.getJSONObject(0));

        } catch (Exception ex) {
            return null;
        }
    }

    // ============================================================
    //                  MÉTODOS GENÉRICOS DE BÚSQUEDA
    // ============================================================
    @Override
    public List<Libro> findByAutor(String autor) {
        return buscarLista("/libros/autor/" + autor);
    }

    @Override
    public List<Libro> findByTitulo(String titulo) {
        return buscarLista("/libros/titulo/" + titulo);
    }

    @Override
    public List<Libro> findByCategoria(String categoria) {
        return buscarLista("/libros/categoria/" + categoria);
    }

    private List<Libro> buscarLista(String path) {
        List<Libro> lista = new ArrayList<>();

        try {
            URL url = new URL(BASE_URL + path);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            JSONArray arr = new JSONArray(br.readLine());

            for (int i = 0; i < arr.length(); i++) {
                lista.add(convertir(arr.getJSONObject(i)));
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return lista;
    }

    // ============================================================
    //             MÉTODO: validarLibroCodigoYTitulo
    // ============================================================
    @Override
    public Libro validarLibroCodigoYTitulo(String codigo, String titulo) {
        try {
            URL url = new URL(BASE_URL + "/libros/validar-libro/" + codigo + "/" + titulo);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            if (con.getResponseCode() != 200) return null;

            BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            JSONObject obj = new JSONObject(br.readLine());

            return convertir(obj);

        } catch (Exception ex) {
            return null;
        }
    }
}

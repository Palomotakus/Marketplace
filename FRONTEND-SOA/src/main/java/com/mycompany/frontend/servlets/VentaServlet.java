/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.frontend.servlets;

import com.google.gson.Gson;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;
import com.google.gson.reflect.TypeToken;
import com.mycompany.frontend.entidades.DetalleVenta;
import com.mycompany.frontend.entidades.ItemCarrito;
import com.mycompany.frontend.entidades.Libro;
import com.mycompany.frontend.entidades.Venta;
import com.mycompany.frontend.servicio.LibroServicio;
import com.mycompany.frontend.servicio.LibroServicioImpl;
import com.mycompany.frontend.servicio.ReniecServicio;
import com.mycompany.frontend.servicio.VentaServicio;
import com.mycompany.frontend.servicio.VentaServicioImpl;
import java.lang.reflect.Type;
import java.time.LocalDateTime;
import java.util.ArrayList;

/**
 *
 * @author luisc
 */
@WebServlet(name = "VentaServlet", urlPatterns = {"/VentaServlet"})
public class VentaServlet extends HttpServlet {

    private LibroServicio libroServicio = new LibroServicioImpl();
    private VentaServicio ventaServicio = new VentaServicioImpl();
    private ReniecServicio dniServicio = new ReniecServicio();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        String jsonCarrito = request.getParameter("jsonCarrito");

        // Cargar lista de libros
        List<Libro> listaLibros = libroServicio.findAll();
        request.setAttribute("listaLibros", listaLibros);

        if (jsonCarrito == null || jsonCarrito.isEmpty()) {
            jsonCarrito = "[]";
        }
        request.setAttribute("carritoLibros", jsonCarrito);

        if (accion == null) {
            request.getRequestDispatcher("ventas.jsp").forward(request, response);
            return;
        }

        if (accion.equals("buscarDni")) {
            String dni = request.getParameter("dni");
            boolean hayDni = false;

            try {
                JSONObject json = dniServicio.buscarPorDni(dni);

                if (json.has("full_name") || json.has("first_name")) {
                    String nombreCompleto = json.optString("first_name", "");
                    String apellidoPaterno = json.optString("first_last_name", "");
                    String apellidoMaterno = json.optString("second_last_name", "");

                    request.setAttribute("dni", dni);
                    request.setAttribute("nombreCompleto", nombreCompleto);
                    request.setAttribute("apellidoPaterno", apellidoPaterno);
                    request.setAttribute("apellidoMaterno", apellidoMaterno);
                    hayDni = true;
                } else {
                    request.setAttribute("error", "Cliente no encontrado. Ingrese los datos manualmente.");
                    request.setAttribute("dni", dni);
                }

            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                request.setAttribute("dni", request.getParameter("dni"));
            } catch (Exception e) {
                request.setAttribute("error", "Error al conectar con el servicio.");
                request.setAttribute("dni", request.getParameter("dni"));
            }

            request.setAttribute("hayDni", hayDni);
            request.setAttribute("carritoLibros", jsonCarrito);
            request.getRequestDispatcher("ventas.jsp").forward(request, response);
        }
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    // Evitar problemas con tildes
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // 1️⃣ Recibir parámetros
    String jsonCarrito = request.getParameter("jsonCarrito");
    String dni = request.getParameter("dni");
    String nombre = request.getParameter("nombre");
    String apellido1 = request.getParameter("apellido1");
    String apellido2 = request.getParameter("apellido2");

    // 2️⃣ Convertir JSON a lista de items
    Gson gson = new Gson();
    Type listType = new TypeToken<List<ItemCarrito>>() {}.getType();
    List<ItemCarrito> carrito = gson.fromJson(jsonCarrito, listType);

    if (carrito == null || carrito.isEmpty()) {
        request.setAttribute("reciboGenerado", false);
        request.getRequestDispatcher("/ventas.jsp").forward(request, response);
        return;
    }

    // 3️⃣ Calcular total y armar lista de detalles
    double total = 0.0;
    List<DetalleVenta> detalles = new ArrayList<>();

    for (ItemCarrito item : carrito) {
        DetalleVenta det = new DetalleVenta();
        det.setIdLibro(Integer.parseInt(item.getCodigo()));
        det.setCantidad(item.getCantidad());
        det.setPrecioUnitario(item.getPrecio());

        detalles.add(det);
        total += item.getCantidad() * item.getPrecio();
    }

    // 4️⃣ Crear objeto Venta
    Venta venta = new Venta();
    venta.setDni(dni);
    venta.setNombre(nombre);
    venta.setApellidoPaterno(apellido1);
    venta.setApellidoMaterno(apellido2);
    venta.setTotal(total);
    venta.setFecha(LocalDateTime.now());
    venta.setEstado("Registrada");

    // 5️⃣ Registrar venta en el microservicio — AHORA devuelve un OBJETO Venta
    Venta ventaRegistrada = ventaServicio.registrarVenta(venta, detalles);

    // 6️⃣ Verificar si la venta se registró correctamente
    if (ventaRegistrada != null && ventaRegistrada.getId() > 0) {

        int idVenta = ventaRegistrada.getId();
        String numeroRecibo = String.format("%06d", idVenta);

        String fechaVenta = new java.text.SimpleDateFormat("dd/MM/yyyy - HH:mm:ss a")
                .format(new java.util.Date());

        // Preparar lista de libros vendidos para el JSP
        List<Libro> librosVendidos = new ArrayList<>();
        for (ItemCarrito item : carrito) {
            Libro libro = new Libro();
            libro.setCodigo(item.getCodigo());
            libro.setTitulo(item.getTitulo());
            libro.setAutor(item.getAutor());
            libro.setPrecio(item.getPrecio() * item.getCantidad());

            librosVendidos.add(libro);

            // Actualizar stock en microservicio de libros
            libroServicio.actualizarStock(Integer.parseInt(item.getCodigo()), item.getCantidad());
        }

        // Enviar atributos al JSP
        request.setAttribute("reciboGenerado", true);
        request.setAttribute("clienteNombre", nombre + " " + apellido1 + " " + apellido2);
        request.setAttribute("clienteDni", dni);
        request.setAttribute("fechaVenta", fechaVenta);
        request.setAttribute("numeroRecibo", numeroRecibo);
        request.setAttribute("totalVenta", total);
        request.setAttribute("librosVendidos", librosVendidos);

        List<Libro> listaLibros = libroServicio.findAll();
        request.setAttribute("listaLibros", listaLibros);

        request.getRequestDispatcher("/ventas.jsp").forward(request, response);

    } else {

        request.setAttribute("reciboGenerado", false);
        request.getRequestDispatcher("/ventas.jsp").forward(request, response);
    }
}


    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

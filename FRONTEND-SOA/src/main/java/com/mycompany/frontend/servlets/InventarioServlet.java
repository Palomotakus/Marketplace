/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs:nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.frontend.servlets;

import com.mycompany.frontend.entidades.Categoria;
import com.mycompany.frontend.entidades.Libro;
import com.mycompany.frontend.servicio.CategoriaServicio;
import com.mycompany.frontend.servicio.CategoriaServicioImpl;
import com.mycompany.frontend.servicio.LibroServicio;
import com.mycompany.frontend.servicio.LibroServicioImpl;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author luisc
 */
@WebServlet(name = "InventarioServlet", urlPatterns = {"/Inventario"})
public class InventarioServlet extends HttpServlet {

    private LibroServicio libroServicio = new LibroServicioImpl();

    private CategoriaServicio categoriaServicio = new CategoriaServicioImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion == null) {
            List<Libro> lista = libroServicio.findAll();
            request.setAttribute("listadoLibros", lista);

            List<Categoria> listaCategoria = categoriaServicio.findAll();
            request.setAttribute("listadoCategorias", listaCategoria);
            request.setAttribute("cantidadCategorias", listaCategoria.size());

            Map<Integer, Integer> librosPorCategoria = categoriaServicio.obtenerCantidadLibrosPorCategoria();
            request.setAttribute("librosPorCategoria", librosPorCategoria);

            Map<String, Integer> resumen = libroServicio.obtenerResumen();
            request.setAttribute("resumen", resumen);

            request.getRequestDispatcher("/inventario.jsp").forward(request, response);

        } else if (accion.equals("eliminar")) {
            int id = Integer.parseInt(request.getParameter("id"));
            libroServicio.eliminar(id);
            response.sendRedirect("Inventario");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if (accion != null && accion.equals("guardarLibro")) {
            Libro l = new Libro();
            l.setCodigo(request.getParameter("codigo"));
            l.setTitulo(request.getParameter("titulo"));
            l.setAutor(request.getParameter("autor"));
            l.setPrecio(Double.parseDouble(request.getParameter("precio")));
            l.setStock(Integer.parseInt(request.getParameter("stock")));

            
                // Asignar la categoría
                Categoria c = new Categoria();
                c.setId(Long.parseLong(request.getParameter("categoria_id")));
                l.setCategoria(c);

                // Si viene el ID → actualización
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    l.setId(Long.parseLong(idParam));
                }

                libroServicio.guardar(l);

                response.sendRedirect("Inventario");
            

        } else if (accion != null && accion.equals("agregarCategoria")) {
            Categoria c = new Categoria();
            c.setNombre(request.getParameter("nombre"));

            if (categoriaServicio.validarCategoriaNombre(c.getNombre()) == null) {
                // Si viene el ID → es actualización
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    c.setId(Long.parseLong(idParam));
                }

                categoriaServicio.guardar(c);

                List<Libro> lista = libroServicio.findAll();
                request.setAttribute("listadoLibros", lista);

                List<Categoria> listaCategoria = categoriaServicio.findAll();
                request.setAttribute("listadoCategorias", listaCategoria);
                request.setAttribute("cantidadCategorias", listaCategoria.size());
                Map<Integer, Integer> librosPorCategoria = categoriaServicio.obtenerCantidadLibrosPorCategoria();
                request.setAttribute("librosPorCategoria", librosPorCategoria);

                Map<String, Integer> resumen = libroServicio.obtenerResumen();
                request.setAttribute("resumen", resumen);

                request.setAttribute("abrirModal", true);

                request.getRequestDispatcher("inventario.jsp").forward(request, response);
            } else {
                List<Libro> lista = libroServicio.findAll();
                request.setAttribute("listadoLibros", lista);

                List<Categoria> listaCategoria = categoriaServicio.findAll();
                request.setAttribute("listadoCategorias", listaCategoria);
                request.setAttribute("cantidadCategorias", listaCategoria.size());
                Map<Integer, Integer> librosPorCategoria = categoriaServicio.obtenerCantidadLibrosPorCategoria();
                request.setAttribute("librosPorCategoria", librosPorCategoria);

                Map<String, Integer> resumen = libroServicio.obtenerResumen();
                request.setAttribute("resumen", resumen);

                request.setAttribute("error", "La categoria ya existe");

                request.setAttribute("abrirModal", true);

                request.getRequestDispatcher("inventario.jsp").forward(request, response);
            }

        } else if ("eliminarCategoria".equals(accion)) {
            String idParam = request.getParameter("id");

            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);

                categoriaServicio.eliminar(id);
            }

            List<Libro> lista = libroServicio.findAll();
            request.setAttribute("listadoLibros", lista);

            Map<Integer, Integer> librosPorCategoria = categoriaServicio.obtenerCantidadLibrosPorCategoria();
            request.setAttribute("librosPorCategoria", librosPorCategoria);

            List<Categoria> listaCategoria = categoriaServicio.findAll();
            request.setAttribute("listadoCategorias", listaCategoria);
            request.setAttribute("cantidadCategorias", listaCategoria.size());

            Map<String, Integer> resumen = libroServicio.obtenerResumen();
            request.setAttribute("resumen", resumen);

            request.setAttribute("abrirModal", true);

            // 👇 Redirige de nuevo a la página de inventario
            request.getRequestDispatcher("inventario.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.mycompany.frontend.servicio;

import com.mycompany.frontend.entidades.Libro;
import java.util.List;
import java.util.Map;

/**
 *
 * @author luisc
 */
public interface LibroServicio {
    
    Libro findById(int id);
    List<Libro> findAll();
    void guardar(Libro empleado);
    void actualizarStock(int idLibro, int cantidadVendida);
    void eliminar(int id);
    Map<String, Integer> obtenerResumen();
    Libro findByCodigo(String codigo);
    List<Libro> findByAutor(String autor);
    List<Libro> findByTitulo(String titulo);
    List<Libro> findByCategoria(String categoria);
    Libro validarLibroCodigoYTitulo(String Codigo, String titulo);
}

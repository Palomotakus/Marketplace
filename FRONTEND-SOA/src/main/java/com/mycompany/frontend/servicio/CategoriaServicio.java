/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.mycompany.frontend.servicio;

import com.mycompany.frontend.entidades.Categoria;
import java.util.List;
import java.util.Map;

/**
 *
 * @author luisc
 */
public interface CategoriaServicio {
    
    Categoria findById(int id);
    List<Categoria> findAll();
    void guardar(Categoria empleado);
    void actualizar(Categoria empleado);
    void eliminar(int id);
    Map<Integer, Integer> obtenerCantidadLibrosPorCategoria();
    Categoria validarCategoriaNombre(String nombre);
}
    


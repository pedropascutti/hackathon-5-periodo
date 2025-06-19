package edu.unialfa.hackathon.repository;

import edu.unialfa.hackathon.model.TipoUsuario;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TipoUsuarioRepository extends JpaRepository<TipoUsuario, Long> {
}

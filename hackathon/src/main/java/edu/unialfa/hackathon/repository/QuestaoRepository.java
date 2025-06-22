package edu.unialfa.hackathon.repository;

import edu.unialfa.hackathon.model.Prova;
import edu.unialfa.hackathon.model.Questao;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface QuestaoRepository extends JpaRepository<Questao, Long> {
    List<Questao> findByProva_Id(Long provaId);

    List<Questao> findByProva(Prova prova);

    Optional<Questao> findByProvaIdAndNumero(Long provaId, String numero);
}

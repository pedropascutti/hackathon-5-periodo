package edu.unialfa.hackathon.service;

import edu.unialfa.hackathon.model.Disciplina;
import edu.unialfa.hackathon.model.Turma;
import edu.unialfa.hackathon.repository.TurmaRepository;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class TurmaService {

    private final TurmaRepository turmaRepository;

    public List<Turma> listarTodas() {
        return turmaRepository.findAll();
    }

    public Turma buscarPorId(Long id) {
        return turmaRepository.findById(id).orElse(null);
    }

    @Transactional
    public void salvar(Turma turma) {
        turmaRepository.save(turma);
    }

    public void deletarPorId(Long id) {
        turmaRepository.deleteById(id);
    }

    public List<Disciplina> listarDisciplinasPorTurma(Long turmaId) {
        return turmaRepository.findById(turmaId)
                .orElseThrow(() -> new RuntimeException("Turma não encontrada"))
                .getDisciplinas();
    }

}
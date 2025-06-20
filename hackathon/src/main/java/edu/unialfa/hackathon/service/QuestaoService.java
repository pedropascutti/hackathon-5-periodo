package edu.unialfa.hackathon.service;

import edu.unialfa.hackathon.model.Questao;
import edu.unialfa.hackathon.repository.QuestaoRepository;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class QuestaoService {
    private final QuestaoRepository repository;

    @Transactional
    public void salvar(Questao questao) {
        repository.save(questao);
    }

    public List<Questao> listarTodos() {
        return repository.findAll();
    }

    public Questao buscarPorId(Long id) {
        return repository.findById(id).get();
    }

    public void deletarPorId(Long id) {
        repository.deleteById(id);
    }
}

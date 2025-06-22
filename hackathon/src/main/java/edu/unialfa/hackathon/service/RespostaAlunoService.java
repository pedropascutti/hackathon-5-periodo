package edu.unialfa.hackathon.service;

import edu.unialfa.hackathon.dto.CorrecaoProvaRequest;
import edu.unialfa.hackathon.dto.RespostaSimplesDTO;
import edu.unialfa.hackathon.model.Aluno;
import edu.unialfa.hackathon.model.Questao;
import edu.unialfa.hackathon.model.RespostaAluno;
import edu.unialfa.hackathon.model.Usuario;
import edu.unialfa.hackathon.repository.ProvaRepository;
import edu.unialfa.hackathon.repository.QuestaoRepository;
import edu.unialfa.hackathon.repository.RespostaAlunoRepository;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class RespostaAlunoService {
    final private RespostaAlunoRepository respostaAlunoRepository;
    private final QuestaoRepository questaoRepository;
    private final AlunoService alunoService;

    public List<RespostaAluno> listarTodas() {
        return respostaAlunoRepository.findAll();
    }

    public RespostaAluno buscarPorId(Long id) {
        return respostaAlunoRepository.findById(id).orElse(null);
    }

    @Transactional
    public void salvar(RespostaAluno respostaAluno) {
        respostaAlunoRepository.save(respostaAluno);
    }

    public void deletarPorId(Long id) {
        respostaAlunoRepository.deleteById(id);
    }

    public void processarRespostas(CorrecaoProvaRequest request) {
        Aluno alunoEntity = alunoService.buscarPorId(request.getIdAluno());
        Long idProva = request.getIdProva();

        for (RespostaSimplesDTO respostaDto : request.getRespostas()) {
            RespostaAluno respostaAluno = new RespostaAluno();

            respostaAluno.setAluno(alunoEntity);

            Optional<Questao> questaoOpt = questaoRepository.findByProvaIdAndNumero(idProva, respostaDto.getNumeroQuestao());

            if (questaoOpt.isPresent()) {
                Questao questao = questaoOpt.get();

                respostaAluno.setProva(questao.getProva());
                respostaAluno.setNumeroQuestao(respostaDto.getNumeroQuestao());
                respostaAluno.setAlternativaEscolhida(respostaDto.getAlternativaEscolhida());

                boolean correta = questao.getAlternativaCorreta().equalsIgnoreCase(respostaDto.getAlternativaEscolhida());
                respostaAluno.setCorreta(correta);

                respostaAlunoRepository.save(respostaAluno);
            }
        }
    }

    public List<RespostaAluno> buscarPorAluno(Long alunoId) {
        return respostaAlunoRepository.findByAlunoId(alunoId);
    }
}

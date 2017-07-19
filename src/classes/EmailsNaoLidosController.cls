public with sharing class EmailsNaoLidosController {
	/*
        Construtor
    */
    public EmailsNaoLidosController() {}

    /*
        Metodo principal de execução
    */
    public void execute() {
        EmailMessageBO.getInstance().updateFieldInCase();            
    }
}
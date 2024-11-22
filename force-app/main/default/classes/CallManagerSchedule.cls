public class CallManagerSchedule implements Schedulable{
    ICallManager callManager;
    
	public CallManagerSchedule(ICallManager callManager) {
        this.callManager = callManager;
    }

    public void execute(SchedulableContext sc) {
        System.enqueueJob(new CallManagerQueueable(callManager));
        abortScheduleJobAfterExecution(sc);
    }

    /**
    * @description Método que borra el Job del shedule despues que se ejecuta, para evitar 
    * la acumulación innecesaria de logs de los jobs completados en Salesforce.
    * @author Juan Felipe Muriel | 20-08-2024 
    * @param sc contexto del Schedule
    */
    private void abortScheduleJobAfterExecution(SchedulableContext sc) {
        System.abortJob(sc.getTriggerId());
    }
}
public class CallManagerQueueable implements Queueable, Database.AllowsCallouts {
	public ICallManager callManager;

    public CallManagerQueueable(ICallManager callManager) {
        this.callManager = callManager;
    }

    public void execute(QueueableContext context) {
        callManager.execute();
    }
}
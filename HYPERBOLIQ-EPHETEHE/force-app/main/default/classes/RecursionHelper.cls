public class RecursionHelper {
	public static Boolean isExecuting = false;

    public static Boolean shouldExecute() {
        if(!isExecuting) {
            isExecuting = true;

            return true;
        }

        return false;
    }
    
    public static void reset() {
        isExecuting = false;
    }
}
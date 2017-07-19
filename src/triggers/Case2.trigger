trigger Case2 on Case (after update) {

	if(Trigger.isUpdate && Trigger.isAfter){
		//check recursive call
		if( !ProcessControl.inFutureContext ) {
			EmailMessageBO.getInstance().updateFieldInCase(Trigger.new);
		}
	}
}
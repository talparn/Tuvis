({
    init : function(component, event, helper) {
		var action1 = component.get("c.candidateRecords");
		action1.setCallback(this, function(response){
		var state = response.getState();
		if (state === "SUCCESS") {
			component.set("v.candidateReocrds", response.getReturnValue());//The attribute that you are iterating has to be set here
		}
		});
		$A.enqueueAction(action1);

		try{
			var action = component.get("c.getInitialParameters");
			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var storeResponse = response.getReturnValue();
					if (storeResponse != null){
						storeResponse = JSON.parse(storeResponse);
						//Get all the fields from the CandidateFieldsForm Field Set
						if (storeResponse.hasOwnProperty('candidateDetailsFieldSet') && storeResponse.candidateDetailsFieldSet.length > 0) {
							var fieldSetFields = new Array();
							for (var i = 0; i < storeResponse.candidateDetailsFieldSet.length; i++){
								var f = {};
								f.name = storeResponse.candidateDetailsFieldSet[i].name;
								f.req = storeResponse.candidateDetailsFieldSet[i].required;
								fieldSetFields.push(JSON.parse(JSON.stringify(f)));
							}
							component.set('v.candidateDetailsFieldSet', fieldSetFields);
							component.set('v.formScreen', true);
						}
					}
				}

				else {
					var errors = response.getError();
				}
			});
			$A.enqueueAction(action);
		}
		catch(e){
			console.error(e);
			console.error('e.name => ' + e.name );
			console.error('e.message => ' + e.message );
			console.error('e.stack => ' + e.stack );
		}
	},

	//When modal is closed --> auto-refresh the page
	closeModal : function(component, event, helper) {
		component.set('v.openModal', false);
		window.location.reload()
    },
	
	handleLoad : function(component, event, helper) {
		component.set('v.formScreen', true);
		var spinner = component.find("cmspinner");
        $A.util.addClass(spinner, "slds-hide");
	},

	//Submit the data populated from the modal
	handleSubmit : function(component, event, helper) {
		try{
			event.preventDefault();
			var spinner = component.find("cmspinner");
			$A.util.removeClass(spinner, "slds-hide");
			component.find('recordEditForm').submit();//fields
		}
		catch(e){
			console.error(e);
			console.error('e.name => ' + e.name );
			console.error('e.message => ' + e.message );
			console.error('e.stack => ' + e.stack );
		}
	},

	handleError: function(component, event) {
        var errors = event.getParams();
		var spinner = component.find("cmspinner");
        $A.util.addClass(spinner, "slds-hide");
    },

	handleSuccess : function(component, event, helper) {
		component.set('v.formScreen', false);
		component.set('v.openModal', false);
		var spinner = component.find("cmspinner");
		$A.util.addClass(spinner, "slds-hide");

		var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				mode: 'sticky',
				"title": "Success!",
				"message": "The record has been updated successfully.",
				"type": "success"
			});
		toastEvent.fire();
		
		window.location.reload()
	},

	//When button is clicked --> opens the new 'New Candidte' modal
	openCandidateForm : function(component, event, helper){
		component.set('v.openModal', true);
		var spinner = component.find("cmspinner");
        $A.util.removeClass(spinner, "slds-hide");
	}
})

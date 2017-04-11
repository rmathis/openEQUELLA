package com.tle.web.sections.header;

import com.tle.web.sections.js.JSCallAndReference;
import com.tle.web.sections.js.JSCallable;
import com.tle.web.sections.js.JSExpression;

public class StandardHeaderHelper implements MutableHeaderHelper
{
	private JSCallable elementFunction;
	private JSExpression formExpression;
	private JSCallable[] submitFunctions;
	private JSCallAndReference triggerEventFunction;

	@Override
	public JSExpression getFormExpression()
	{
		return formExpression;
	}

	@Override
	public void setFormExpression(JSExpression formExpression)
	{
		this.formExpression = formExpression;
	}

	@Override
	public JSCallable getElementFunction()
	{
		return elementFunction;
	}

	@Override
	public void setElementFunction(JSCallable elementFunction)
	{
		this.elementFunction = elementFunction;
	}

	@Override
	public JSCallable getSubmitFunction(boolean validate, boolean event)
	{
		return getSubmitFunction(validate, event, true);
	}

	@Override
	public JSCallable getSubmitFunction(boolean validate, boolean event, boolean blockFurtherSubmission)
	{
		return submitFunctions[(event ? 0 : 4) + (validate ? 0 : 2) + (blockFurtherSubmission ? 0 : 1)];
	}

	@Override
	public void setSubmitFunctions(JSCallable submit, JSCallable submitNV, JSCallable submitEvent,
		JSCallable submitEventNV)
	{
		setSubmitFunctions(submit, submitNV, submitNV, submitEvent, submitEventNV, submitEventNV);
	}

	@Override
	public void setSubmitFunctions(JSCallable submit, JSCallable submitNoValidation, JSCallable submitNoBlockNoVal,
		JSCallable submitEvent, JSCallable submitEventNoValidation, JSCallable submitEventNoBlockNoVal)
	{
		submitFunctions = new JSCallable[]{submit, submitNoBlockNoVal, submitNoValidation, submitNoBlockNoVal,
				submitEvent, submitEventNoBlockNoVal, submitEventNoValidation, submitEventNoBlockNoVal};
	}

	@Override
	public JSCallAndReference getTriggerEventFunction()
	{
		return triggerEventFunction;
	}

	@Override
	public void setTriggerEventFunction(JSCallAndReference triggerEventFunction)
	{
		this.triggerEventFunction = triggerEventFunction;
	}

	@Override
	public boolean isSubmitFunctionsSet()
	{
		return submitFunctions != null;
	}
}

public with sharing class Pm1_DerivedClass extends Pm1_BaseClass {
	private Integer numberInput;
    
    public Pm1_DerivedClass() {
		numberInput = 0;
    }
    
    public Pm1_DerivedClass(Integer initNumberInput) {    	
		super(initNumberInput);
		numberInput = initNumberInput;
    }
    
    public override Integer getNumber() {
    	return numberInput * 2;
    }
    
    public override Integer squared() {
    	return numberInput * numberInput;
    }
}
/**
*  ================================================================================================
*   Version    Date          Author                        Comment
*  ================================================================================================
*   v1.0     Jan-5-2018   Manish Patil  	Programmatic Model - 1 Derived Class example
*/
public with sharing class Pm1_DerivedClass extends Pm1_BaseClass {
	private Integer numberInput;
    
    public Pm1_DerivedClass() {
		numberInput = 0;
    }
    
    public Pm1_DerivedClass(Integer initNumberInput) {    	
		super(initNumberInput);
		numberInput = initNumberInput;
    }
    
    /**
    * Overridden  method from base class
    **/
    public override Integer getNumber() {
    	return numberInput * 2;
    }
    
    /**
    * Overridden Abstract method from base class
    **/
    public override Integer squared() {
    	return numberInput * numberInput;
    }
}
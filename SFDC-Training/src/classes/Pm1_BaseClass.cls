/**
*  ================================================================================================
*   Version    Date          Author                        Comment
*  ================================================================================================
*   v1.0     Jan-5-2018   Manish Patil  	Programmatic Model - 1 Base class example
*/
public abstract with sharing class Pm1_BaseClass {
    
    private Integer numberInput;
    
    public Pm1_BaseClass() {
    	numberInput = 0;
    }
    public Pm1_BaseClass(Integer initializeNumberInput) {
    	numberInput = initializeNumberInput;
    }

    /**
    * Abstract method example
    **/
    public abstract Integer squared();
    
    /**
    * Virtual method example
    **/
    public virtual Integer getNumber() {
    	return numberInput;
    }        
}
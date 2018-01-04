public abstract with sharing class Pm1_BaseClass {
    
    private Integer numberInput;
    
    public Pm1_BaseClass() {
    	numberInput = 0;
    }
    public Pm1_BaseClass(Integer initializeNumberInput) {
    	numberInput = initializeNumberInput;
    }
    
    public abstract Integer squared();
    
    public virtual Integer getNumber() {
    	return numberInput;
    }        
}
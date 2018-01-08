public class StringArrayTest {
    public static List<String> generateStringArray(Integer length){
        List<String> strArray = new List<String>();
        for (Integer i=0; i<length;i++){
            strArray.add('Test ' + i);
        }
        return strArray;
    }
}
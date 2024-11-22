/**
 * @description Clase cuyo objetivo es definir la estructura a utilizar en las peticiones y en las respuestas 
 * de la API de precios
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 05-08-2024 - Creación
 */
public class PricingAPIWrapper {
    // Atributos usados para guardar los logs
    public Datetime requestDateTime;
    public Datetime responseDateTime;
    public String status;
    public String callOutErrorMessage;
    public String salesforceErrorMessage;
    public Integer httpCode;
    public PricingAPIWrapper.Request requestData;
    public PricingAPIWrapper.Response responseData;

    public PricingAPIWrapper(){
        this.requestData = new Request();
        this.responseData = new Response();
    }

    /**
     * @description Clase encargada de definir la estructura del cuerpo de la petición a enviar a la API
     * @example
     * {"rentalObjects": ["PL1009"],"mallCode": "PNO","ceBe": "1102204","category": "Autoplaza","sector": "SR852","areaM2": "100"}
     */
    public class Request{
        public Set<String> rentalObjects{ get; set; }
        public String mallCode{ get; set; }
        public String ceBe{ get; set; }
        public String category{ get; set; }
        public String sector{ get; set; }
        public Decimal areaM2{ get; set; }
    }

    /** 
     * @description Clase encargada de definir la estructura de la respuesta de la API 
     * @example 
     * {"pricing": 2.9,"message": [{"code": "X0002","description": "RentalObject no fue encontrado, calculo no considera pasillo"}]}
    */
    public class Response{
        
        public Decimal pricing{ get; set; }
        public List<Message> message{ get; set; }

        public Response(){
            message = new List<message>();
        }
    }

    /** 
     * @description Clase encargada de definir la estructura del objeto 'Mensaje' recibido en la respuesta de la API 
     * @example 
     * {"code": "X0002","description": "RentalObject no fue encontrado, calculo no considera pasillo"}
     * */
    public class Message{
        public String code{ get; set; }
        public String description{ get; set; }
    }
}
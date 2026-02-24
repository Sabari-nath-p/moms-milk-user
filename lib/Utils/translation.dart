import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'good_afternoon': 'Good Afternoon',
          'tracking_journey': "Tracking adam's journey",
          'feeding': 'Feeding',
          'feeding_desc': 'Track breast or bottle feeding',
          'log_feeding': 'Log Feeding',
          'diaper': 'Diaper',
          'diaper_desc': 'Track wet, soiled, or both',
          'log_diaper': 'Log Diaper Change',
          'sleep': 'Sleep',
          'sleep_desc': "Track baby's sleep patterns",
          'log': 'Log',
          'report': 'Report',
          'connect': 'Connect',
          'message': 'Message',
          'profile': 'Profile',
        },
        'es': {
          'good_afternoon': 'Buenas tardes',
          'tracking_journey': "Seguimiento del viaje de Adam",
          'feeding': 'Alimentación',
          'feeding_desc': 'Registrar lactancia o biberón',
          'log_feeding': 'Registrar alimentación',
          'diaper': 'Pañal',
          'diaper_desc': 'Registrar mojado, sucio o ambos',
          'log_diaper': 'Registrar cambio de pañal',
          'sleep': 'Sueño',
          'sleep_desc': 'Registrar patrones de sueño del bebé',
          'log': 'Registro',
          'report': 'Informe',
          'connect': 'Conectar',
          'message': 'Mensaje',
          'profile': 'Perfil',
        },
      };
}
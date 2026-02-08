# mel

Mel! Tu App de Pago

 Resumen del Proyecto

    Mel! Tu App de Pago es una solución móvil diseñada para democratizar el acceso a herramientas de gestión de ventas. El proyecto nace de observar la brecha tecnológica en ferias y puestos ambulantes, donde el costo y tamaño de los sistemas de hardware tradicionales (POS) resultan prohibitivos o poco prácticos.

 Objetivo

    Proporcionar una herramienta ágil y eficiente para dispositivos móviles que permita a emprendedores y vendedores itinerantes registrar sus ventas, gestionar el flujo de caja en tiempo real y diferenciar métodos de pago sin necesidad de infraestructura compleja.

 Análisis Funcional y Flujo

    El sistema se diseñó bajo una premisa de simplicidad y eficiencia operativa en entornos de alta rotación (como ferias).

        1. Configuración de Sesión (Apertura de Caja)

        Al iniciar, el sistema requiere la parametrización de los valores iniciales para garantizar la integridad de los datos:

        Identificación: Registro del operador.(Ahora cumple una funcionalidad decorativa, pero es para una futura escabilidad del proyecto)

        Fondo de Cambio: Monto en efectivo físico destinado a dar vueltos.

        Capital Digital: Dinero disponible en cuenta de Mercado Pago para conciliación posterior.

        2. Gestión de Cobros (Módulo Transaccional)

        El sistema diferencia los flujos de trabajo según el método de pago, optimizando los pasos necesarios para cada uno:

        Flujo Efectivo:

        Ingreso de precio unitario y cantidad.

        Función de agregación de múltiples productos.

        Módulo de Cálculo de Cambio: El sistema procesa el pago recibido y dicta automáticamente el vuelto al usuario para reducir errores humanos.

        Flujo Mercado Pago (Transferencia):

        Registro directo de ingreso.

        Omisión del cálculo de vuelto por naturaleza del medio de pago (conciliación exacta).

        3. Consolidación y Cierre

        Acumulación en Tiempo Real: La pantalla de cobro muestra el acumulado de ventas brutas de la sesión activa.

        Cierre de Caja: Función de liquidación que detalla el total vendido y la ganancia neta obtenida.

        Historial Local: Una vez cerrada la caja, la sesión se archiva en un historial persistente accesible desde la pantalla de inicio.

 Stack Tecnológico

    Lenguaje: Dart

    Framework: Flutter (Arquitectura multiplataforma)

    Persistencia de Datos: Shared Preferences (Almacenamiento local de historial y estados de caja)

    Diseño de Identidad: Icono personalizado

 Visión del proyecto

 Este proyecto representa la convergencia entre el análisis de necesidades de negocio en sectores no digitalizados y la implementación de soluciones tecnológicas modernas y escalables.

Desarrollado con fines de optimización de micro-emprendimientos


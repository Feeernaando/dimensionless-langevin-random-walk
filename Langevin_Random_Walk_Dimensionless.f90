PROGRAM Langevin_Random_Walk
    
    USE, INTRINSIC :: IEEE_ARITHMETIC
    
    IMPLICIT NONE
    INTEGER, PARAMETER :: DP = SELECTED_REAL_KIND(8)
    INTEGER, PARAMETER :: IDP = SELECTED_INT_KIND(32)
    INTEGER(KIND=IDP) :: i = 0.0, j = 0.0
    
    !Since the equation is dimensionless theres no need of declaring values for the physcal constants of the equation.
    !Again since the equation is dimensionless the magnitude of dt does not have to be provided althoug I include it so
    !the user can experiment changing the magnitude and notice no change at all.
    REAL(KIND=DP), PARAMETER :: DeltaT = 1
    !Here you declare the amount of iterations to be performed during the walk. I you need to perform 10^10 or pllus iterations
    !you need to indicate to the compiler using -fno-range-check.
    INTEGER(KIND=IDP), PARAMETER :: N = 1000
    
    !Variables to adjust details to name the file containing the random steps
    CHARACTER(LEN=120) :: WALK
    
    !Variables for the random walk routine
    REAL(KIND=DP) :: R = 0.0, START=0.0, FINISH=0.0
    REAL(KIND=DP) :: V_dt_plus_t = 0.0, V_dt = 0.0
    REAL(KIND=DP) :: Emergency_Dummy = 0.0
    CHARACTER(LEN=30) :: date_time
    
    !To measure the execution time.	
    CALL CPU_TIME(START)
    
    !Beginning time
    CALL fdate(date_time)
    WRITE(*,*) 'Begin time:',date_time
    
    !Llamamos a la función de manejo de archivos
    CALL File_Naming(DeltaT,N,WALK)
    
    !The file where to store the random walk is opened.
    OPEN(UNIT=11,FILE=WALK,STATUS='UNKNOWN',ACTION='WRITE')
    
    WRITE(*,*) 'Simulation starts'
    
    !Here the intial random number to begin the walk is decided.
    CALL Random_StdNormal(R)
    
    V_dt = ( V_dt_plus_t*DeltaT ) + ( SQRT( DeltaT )*(R) )
    V_dt_plus_t = V_dt
    
    !DO cycle to perform the random walk
    DO i=1, N
    
        Emergency_Dummy = V_dt_plus_t 
        
        CALL Random_StdNormal(R)
        V_dt_plus_t = ( V_dt_plus_t*DeltaT ) + ( SQRT( DeltaT )*(R) )
        
        IF ( (ieee_is_finite(V_dt_plus_t) .neqv. .TRUE.) ) THEN
            
            V_dt_plus_t = Emergency_Dummy
    
        END IF
        
        WRITE(11,*) V_dt_plus_t
    
    END DO
    
    WRITE(*,*) 'Number of steps that resulted in a very big number that could not be handled by memory', j
    WRITE(*,*) 'out of N =', i,' spected iterations.'
    
    CALL CPU_TIME(FINISH)
    WRITE(*,*)'The execution time was of', FINISH-START,'seconds.'
    
    !End time
    CALL FDATE(date_time)
    WRITE(*,*) 'End time:',date_time
    
    END PROGRAM
    
    !Function that generates random numbers taken from a normal distribution with mean 0 and varaince 1.
    !The method to obtain the numbers is Box-Muller.
    SUBROUTINE Random_StdNormal(x)
       
       IMPLICIT NONE
       INTEGER, PARAMETER :: DP = SELECTED_REAL_KIND(8)
       INTEGER, PARAMETER :: IDP = SELECTED_INT_KIND(32)
       REAL(KIND=DP), INTENT(OUT) :: X
       REAL(KIND=DP), PARAMETER :: Pi=3.14159265
       REAL(KIND=DP) :: U1,U2
       call RANDOM_NUMBER(U1)
       call RANDOM_NUMBER(U2)
       X = SQRT(-2*LOG(U1))*cos(2*Pi*U2) 
       RETURN
       
    END SUBROUTINE Random_StdNormal
    
    !Function to handle the naming of the file where the randmos steps are stored.
    SUBROUTINE File_Naming(DeltaT,N,NAMEFILE_WALK)
        
        IMPLICIT NONE
        INTEGER, PARAMETER :: DP = SELECTED_REAL_KIND(8)
        INTEGER, PARAMETER :: IDP = SELECTED_INT_KIND(32)
        REAL(KIND=DP) :: DeltaT 
        INTEGER(KIND=IDP) :: N
        CHARACTER(LEN=170) :: GNRIC_NAME_1 = 'STEPS_RNDM_WALK'
        CHARACTER(LEN=120) :: TYPE = '.dat'
        CHARACTER(LEN=120) :: IDFILE, NAMEFILE_WALK, DeltaTC, NC
    
        WRITE(*,*) 'The format of the name of the file is the following:'
        WRITE(*,*) 'ID file, dt size, number of steps'
        WRITE(*,*) 'Introduce the ID of the file'
        READ(*,*) IDFILE 
        
        WRITE( DeltaTC, '(F8.4)' ) DeltaT
        WRITE( NC, '(I10.10)' ) N
         
        !The name of the file is built.
        NAMEFILE_WALK = TRIM(GNRIC_NAME_1)  // '_' // TRIM(IDFILE) // '_' // TRIM(DeltaTC) &
        // '_' // TRIM(NC) // '_' // TRIM(TYPE)
        WRITE(*,*) 'The name of the file that store the steps of the random walk is:'
        WRITE(*,*) NAMEFILE_WALK
         
        RETURN
    
    END SUBROUTINE
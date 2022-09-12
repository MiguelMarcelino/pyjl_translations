Update documentation
====================

Run build
---------

1. Change to documentation root

    ```shell
    cd docs
    ```

1. Activate virtualenv

    ```shell
    source <PATH/TO/VIRTUALENV>/bin/activate
    ```
    
1. Run sphinx build

    ```shell
    python <PATH/TO/VIRTUALENV>/bin/sphinx-build -b html -d build/doctrees/ source/ build/html/
    ```
### Taken from MlFlow documentation ###

import mlflow.sklearn
from mlflow.models import infer_signature
from sklearn import tree
from sklearn.datasets import load_iris

from load_values import load_env_values

load_env_values(".env")

try:
    mlflow.create_experiment(os.environ["EXPERIMENT_NAME"], os.environ["BUCKET_URL"])
except mlflow.MlflowException:
    pass

mlflow.set_experiment(os.environ["EXPERIMENT_NAME"])

with mlflow.start_run():
    # load dataset and train model
    iris = load_iris()
    sk_model = tree.DecisionTreeClassifier()
    sk_model = sk_model.fit(iris.data, iris.target)

    # log model params
    mlflow.log_param("criterion", sk_model.criterion)
    mlflow.log_param("splitter", sk_model.splitter)
    signature = infer_signature(iris.data, sk_model.predict(iris.data))

    # log model
    mlflow.sklearn.log_model(sk_model, "sk_models", signature=signature)

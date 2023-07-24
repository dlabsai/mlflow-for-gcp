import configparser
import os

import mlflow


def load_env_values(link_to_env_file) -> None:
    config = configparser.ConfigParser(interpolation=None)
    config.sections()
    config.read(link_to_env_file)

    os.environ["MLFLOW_TRACKING_USERNAME"] = config["mlflow"]["MLFLOW_TRACKING_USERNAME"]
    os.environ["MLFLOW_TRACKING_PASSWORD"] = config["mlflow"]["MLFLOW_TRACKING_PASSWORD"]
    os.environ["MLFLOW_TRACKING_URI"] = config["mlflow"]["MLFLOW_TRACKING_URI"]
    os.environ["MLFLOW_SERVER_FILE_STORE"] = config["mlflow"]["MLFLOW_SERVER_FILE_STORE"]
    os.environ["BUCKET_URL"] = config["mlflow"]["BUCKET_URL"]
    os.environ["EXPERIMENT_NAME"] = config["mlflow"]["EXPERIMENT_NAME"]


def load_model(link_to_model_folder, link_to_destination_folder):
    mlflow.set_tracking_uri(os.environ["MLFLOW_TRACKING_URI"])
    mlflow.sklearn.load_model(
        link_to_model_folder, link_to_destination_folder)


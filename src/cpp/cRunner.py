import subprocess
from codecarbon import EmissionsTracker
import pandas as pd


def compile_cpp():
    try:
        # Compila il codice C++
        subprocess.run(["make"], check=True)
        print("Compilazione completata con successo.")
    except subprocess.CalledProcessError as e:
        print("Errore durante la compilazione:")
        print(e)
        print("Output di errore:")
        print(e.stderr)


def run_cpp_program(dataset, algorithm):
    compile_cpp()
    try:
        # Esegui l'eseguibile compilato
        result = subprocess.run(
            ["./src/cRunner", dataset, algorithm],
            capture_output=True,
            text=True,
            check=True,
        )
        print("Output del programma C++:")
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print("Errore durante l'esecuzione del programma C++:")
        print(e)
        print("Output di errore:")
        print(e.stderr)


def main():
    datasets = ["breast_cancer", "wine_quality", "iris"]
    algorithms = [
        "logreg",
        "xgboost",
        "decision_tree",
        "random_forest",
        "knn",
        "svc",
        # "GMM",
    ]
    repetition = 1
    new_data = []
    new_csv_filename = (
        "emissions_detailed.csv"  # Choose an appropriate name for the new file
    )

    for dataset in datasets:
        for algorithm in algorithms:
            for _ in range(repetition):

                tracker = EmissionsTracker(
                    output_dir="emissions", output_file="emissions.csv"
                )
                # TODO: overwrite emission.csv or delete every time
                tracker.start()

                print("Executing Cpp script:")
                print(f"with {dataset} , {algorithm}")

                # Run the model and capture the result
                run_cpp_program(dataset, algorithm)

                tracker.stop()

                # Print the result

                new_data.append(
                    {"Algorithm": algorithm, "Dataset": dataset, "Language": "cpp"}
                )

    emissions_df = pd.read_csv("emissions/emissions.csv")
    new_data_df = pd.DataFrame(new_data)
    assert len(new_data_df) == len(
        emissions_df
    ), "Mismatch in row count between emissions data and new columns."
    emissions_df = pd.concat([emissions_df, new_data_df], axis=1)
    emissions_df.to_csv(f"emissions/{new_csv_filename}", index=False)

    print(f"{new_csv_filename} has been created with new columns.")


# main
if __name__ == "__main__":
    main()
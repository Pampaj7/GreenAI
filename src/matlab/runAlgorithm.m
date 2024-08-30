function runAlgo(algorithm, dataset)
    % Carica i dati
    pyenv('Version', '/Users/pampaj/anaconda3/envs/sw/bin/python');
    insert(py.sys.path, int32(0), '/Users/pampaj/PycharmProjects/SWAM/src/matlab/');

    switch dataset
        case 'breastCancer'
            data = readtable('../datasets/breastcancer/breastcancer.csv');
            data.diagnosis = double(categorical(data.diagnosis)) - 1; % 1 per 'M', 0 per 'B'
            X = data{:, setdiff(data.Properties.VariableNames, {'diagnosis', 'id'})};
            y = data.diagnosis;
        case 'wine'
            data = readtable('../datasets/winequality/wine_data.csv', 'ReadVariableNames', false);

            % Definisci i nomi delle colonne
            data.Properties.VariableNames = {'fixed_acidity', 'volatile_acidity', 'citric_acid', 'residual_sugar', ...
                                             'chlorides', 'free_sulfur_dioxide', 'total_sulfur_dioxide', 'density', ...
                                             'pH', 'sulphates', 'alcohol', 'quality', 'type'};

            X = data{:, 1:end-1};
            y = data.quality;
        case 'iris'
            data = readtable('../datasets/iris/iris.csv', 'ReadVariableNames', false);

            % Definisci i nomi delle colonne
            data.Properties.VariableNames = {'sepal_length', 'sepal_width', 'petal_length', 'petal_width', 'species'};

            % Trasforma le specie in numeri
            y = double(categorical(data.species)); % Converti le specie in numeri
            X = data{:, setdiff(data.Properties.VariableNames, {'species'})}; % Usa tutte le colonne tranne 'species'
        otherwise
            error('Dataset unknown');
    end

    % Standardizza i dati
    X = normalize(X);

    % Divisione dei dati in set di addestramento e di test
    cv = cvpartition(y, 'HoldOut', 0.2);
    X_train = X(training(cv), :);
    X_test = X(test(cv), :);
    y_train = y(training(cv));
    y_test = y(test(cv));

    % Inizio tracciamento prima del fitting
    py.tracker_control.start_tracker('matlab/models', sprintf('%s_%s_train_emissions.csv', algorithm, dataset));

    % Seleziona l'algoritmo e addestra il modello
    switch algorithm
        case 'logisticRegression'
            model = fitcecoc(X_train, y_train, 'Learners', 'linear');
        case 'XGBoost'
            % Nota: MATLAB non ha una funzione diretta per XGBoost, quindi usa un'alternativa o libreria se disponibile
            model = fitcensemble(X_train, y_train, 'Method', 'Bag', 'Learners', 'tree');
        case 'decisionTree'
            model = fitctree(X_train, y_train);
        case 'randomForest'
            model = fitcensemble(X_train, y_train, 'Method', 'Bag', 'Learners', 'tree');
        case 'KNN'
            model = fitcknn(X_train, y_train, 'NumNeighbors', 5);
        case 'SVC'
            model = fitcecoc(X_train, y_train);
        case 'GMM'
            options = statset('MaxIter', 1000, 'TolFun', 1e-5);
            model = fitgmdist(X_train, 3, 'Options', options, 'CovarianceType', 'diagonal', 'RegularizationValue', 0.1); %regiularizan value is added!
        otherwise
            error('Algorithm unknown');
    end

    % Stop tracciamento dopo il fitting e prima della predizione
    py.tracker_control.stop_tracker();

    % Inizio tracciamento prima della predizione
    py.tracker_control.start_tracker('matlab/models', sprintf('%s_%s_test_emissions.csv', algorithm, dataset));

    % Calcola le predizioni
    switch algorithm
        case 'GMM'
            y_pred = cluster(model, X_test);
        otherwise
            y_pred = predict(model, X_test);
    end

    % Stop tracciamento dopo la predizione
    py.tracker_control.stop_tracker();

    % Calcola l'accuratezza
    accuracy = sum(y_pred == y_test) / length(y_test);
    fprintf('Accuracy for %s on %s: %.2f%%\n', algorithm, dataset, accuracy * 100);
end
